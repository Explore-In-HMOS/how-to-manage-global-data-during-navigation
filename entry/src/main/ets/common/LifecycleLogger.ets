import { hilog } from '@kit.PerformanceAnalysisKit';
import { LogConfig } from './Constants';

export enum EntryKind {
  LIFECYCLE,
  WRITE,
  READ,
  NAV,
  NOTE
}

export class LogEntry {
  seq: number;
  page: string;
  event: string;
  value: string;
  kind: EntryKind;
  stale: boolean;

  constructor(seq: number, page: string, event: string, value: string, kind: EntryKind, stale: boolean) {
    this.seq = seq;
    this.page = page;
    this.event = event;
    this.value = value;
    this.kind = kind;
    this.stale = stale;
  }
}

export type LogListener = (entries: LogEntry[]) => void;

class LifecycleLogger {
  private seq: number = 0;
  private entries: LogEntry[] = [];
  private listeners: LogListener[] = [];
  private notifyScheduled: boolean = false;
  private expected: number | undefined = undefined;

  lifecycle(page: string, event: string, value?: number): void {
    this.add(page, event, value, EntryKind.LIFECYCLE, false);
  }

  write(page: string, event: string, value: number): void {
    this.add(page, event, value, EntryKind.WRITE, false);
  }

  read(page: string, event: string, value: number): void {
    const stale = this.expected !== undefined && value !== this.expected;
    this.add(page, event, value, EntryKind.READ, stale);
  }

  nav(event: string, detail: string): void {
    this.add('Nav', `${event} ${detail}`, undefined, EntryKind.NAV, false);
  }

  expect(value: number): void {
    this.expected = value;
    this.add('User', 'tapped Save', value, EntryKind.NOTE, false);
  }

  beginFlow(title: string): void {
    this.expected = undefined;
    this.add('----', title, undefined, EntryKind.NOTE, false);
  }

  getEntries(): LogEntry[] {
    return this.entries.slice();
  }

  tail(count: number): LogEntry[] {
    return this.entries.slice(Math.max(0, this.entries.length - count));
  }

  clear(): void {
    this.entries = [];
    this.expected = undefined;
    this.scheduleNotify();
  }

  subscribe(listener: LogListener): void {
    this.listeners.push(listener);
  }

  unsubscribe(listener: LogListener): void {
    this.listeners = this.listeners.filter((l: LogListener) => l !== listener);
  }

  private add(page: string, event: string, value: number | undefined, kind: EntryKind, stale: boolean): void {
    this.seq++;
    const valueText = value === undefined ? '' : value.toString();
    const entry = new LogEntry(this.seq, page, event, valueText, kind, stale);
    this.entries.push(entry);
    if (this.entries.length > LogConfig.MAX_ENTRIES) {
      this.entries.shift();
    }
    const staleMark = stale ? ' STALE' : '';
    hilog.info(LogConfig.DOMAIN, LogConfig.TAG, '#%{public}d %{public}s %{public}s =%{public}s%{public}s',
      entry.seq, page, event, valueText, staleMark);
    this.scheduleNotify();
  }

  private scheduleNotify(): void {
    if (this.notifyScheduled) {
      return;
    }
    this.notifyScheduled = true;
    setTimeout(() => {
      this.notifyScheduled = false;
      const snapshot = this.getEntries();
      this.listeners.forEach((l: LogListener) => l(snapshot));
    }, 0);
  }
}

export const logger: LifecycleLogger = new LifecycleLogger();
