import { LogEntry, LogListener, logger } from '../common/LifecycleLogger';
import {
  ArcList, ArcListAttribute, ArcListItem, ArcListItemAttribute, ComponentContent, LengthMetrics
} from '@kit.ArkUI';
import { ArcListLayout, Palette } from '../common/Constants';
import { ArcHeaderParams, createArcHeader } from './components/ArcHeader';
import { LogRow } from './components/LogRow';

@Builder
export function LogPageBuilder() {
  LogPage()
}

@Component
struct LogPage {
  @State entries: LogEntry[] = logger.getEntries();
  private header?: ComponentContent<ArcHeaderParams>;
  private listener: LogListener = (entries: LogEntry[]) => {
    this.entries = entries;
  };

  aboutToAppear(): void {
    this.header = createArcHeader(this.getUIContext(), 'Lifecycle log');
    logger.subscribe(this.listener);
  }

  aboutToDisappear(): void {
    logger.unsubscribe(this.listener);
  }

  build() {
    NavDestination() {
      ArcList({ header: this.header }) {
        ArcListItem() {
          Button('Clear')
            .id('clearLogBtn')
            .height(28)
            .padding({ left: 16, right: 16 })
            .fontSize(11)
            .fontColor(Palette.TEXT)
            .backgroundColor(Palette.SURFACE_HI)
            .onClick(() => logger.clear())
        }

        ArcListItem() {
          Text() {
            Span('write ').fontColor(Palette.WRITE)
            Span('read ').fontColor(Palette.READ)
            Span('stale ').fontColor(Palette.BAD)
            Span('nav ').fontColor(Palette.NAV)
            Span('lifecycle').fontColor(Palette.MUTED)
          }
          .fontSize(10)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ bottom: 4 })
        }

        ForEach(this.entries, (entry: LogEntry) => {
          ArcListItem() {
            Column() {
              LogRow({ entry: entry, fontSize: 11 })
            }
            .width(ArcListLayout.ITEM_WIDTH)
          }
          .autoScale(false)
        }, (entry: LogEntry) => entry.seq.toString())
      }
      .width('100%')
      .height('100%')
      .space(LengthMetrics.vp(ArcListLayout.SPACE))
      .digitalCrownSensitivity(CrownSensitivity.MEDIUM)
      .scrollBar(BarState.Off)
    }
    .hideTitleBar(true)
    .backgroundColor(Palette.BG)
  }
}
