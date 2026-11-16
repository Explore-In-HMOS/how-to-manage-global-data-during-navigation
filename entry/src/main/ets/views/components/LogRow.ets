import { EntryKind, LogEntry } from '../../common/LifecycleLogger';
import { Palette } from '../../common/Constants';

export function colorFor(entry: LogEntry): string {
  if (entry.stale) {
    return Palette.BAD;
  }
  switch (entry.kind) {
    case EntryKind.WRITE:
      return Palette.WRITE;
    case EntryKind.READ:
      return Palette.READ;
    case EntryKind.NAV:
      return Palette.NAV;
    case EntryKind.NOTE:
      return Palette.TEXT;
    default:
      return Palette.MUTED;
  }
}

@Component
export struct LogRow {
  @Prop entry: LogEntry;
  @Prop fontSize: number = 11;

  build() {
    Text() {
      Span(`${this.entry.seq} `).fontColor(Palette.MUTED)
      Span(`${this.entry.page} `).fontWeight(FontWeight.Medium)
      Span(this.entry.event)
      Span(this.entry.value.length > 0 ? ` =${this.entry.value}` : '')
      Span(this.entry.stale ? ' ⚠ STALE' : '').fontWeight(FontWeight.Bold)
    }
    .fontSize(this.fontSize)
    .fontColor(colorFor(this.entry))
    .maxLines(2)
    .textOverflow({ overflow: TextOverflow.Ellipsis })
    .textAlign(TextAlign.Start)
    .width('100%')
    .padding({ top: 1, bottom: 1, left: 4, right: 4 })
    .backgroundColor(this.entry.stale ? '#33FF453A' : Color.Transparent)
    .borderRadius(4)
  }
}
