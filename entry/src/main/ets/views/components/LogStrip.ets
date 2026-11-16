import { LogEntry, LogListener, logger } from '../../common/LifecycleLogger';
import { LogConfig, Palette } from '../../common/Constants';
import { LogRow } from './LogRow';

@Component
export struct LogStrip {
  @State lines: LogEntry[] = logger.tail(LogConfig.STRIP_ENTRIES);
  private listener: LogListener = (entries: LogEntry[]) => {
    this.lines = entries.slice(Math.max(0, entries.length - LogConfig.STRIP_ENTRIES));
  };

  aboutToAppear(): void {
    logger.subscribe(this.listener);
  }

  aboutToDisappear(): void {
    logger.unsubscribe(this.listener);
  }

  build() {
    Column({ space: 1 }) {
      ForEach(this.lines, (entry: LogEntry) => {
        LogRow({ entry: entry, fontSize: 10 })
      }, (entry: LogEntry) => entry.seq.toString())
    }
    .width('100%')
    .padding(6)
    .borderRadius(12)
    .backgroundColor(Palette.SURFACE)
  }
}
