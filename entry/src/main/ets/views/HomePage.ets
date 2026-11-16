import {
  ArcList, ArcListAttribute, ArcListItem, ArcListItemAttribute, ComponentContent, LengthMetrics
} from '@kit.ArkUI';
import { AppLog } from '../common/AppLog';
import { logger } from '../common/LifecycleLogger';
import { ArcListLayout, Palette, Routes } from '../common/Constants';
import { ArcHeaderParams, createArcHeader } from './components/ArcHeader';
import { RouteManager } from '../common/RouteManager';

class MenuItem {
  id: string;
  title: string;
  subtitle: string;
  route: string;
  color: string;
  startsFlow: boolean;

  constructor(id: string, title: string, subtitle: string, route: string, color: string, startsFlow: boolean) {
    this.id = id;
    this.title = title;
    this.subtitle = subtitle;
    this.route = route;
    this.color = color;
    this.startsFlow = startsFlow;
  }
}

const MENU: MenuItem[] = [
  new MenuItem('menuBroken', '1 · Broken', 'write in aboutToDisappear', Routes.DASH_BROKEN, Palette.BAD, true),
  new MenuItem('menuAppStorage', '2 · AppStorage', '@StorageProp + set before pop', Routes.DASH_AS, Palette.GOOD, true),
  new MenuItem('menuPopResult', '3 · pop(result)', 'NavPathInfo onPop', Routes.DASH_PR, Palette.GOOD, true),
  new MenuItem('menuRouteManager', '4 · RouteManager', 'commit, then pop', Routes.DASH_RM, Palette.GOOD, true),
  new MenuItem('menuLog', 'Lifecycle log', 'full ordered log', Routes.LOG, Palette.READ, false),
  new MenuItem('menuCompare', 'Compare', 'which approach when', Routes.COMPARE, Palette.NAV, false)
];

@Component
export struct HomePage {
  private header?: ComponentContent<ArcHeaderParams>;

  aboutToAppear(): void {
    this.header = createArcHeader(this.getUIContext(), 'NavSync');
  }

  build() {
    ArcList({ header: this.header }) {
      ArcListItem() {
        Text('Data timing in Navigation')
          .fontSize(11)
          .fontColor(Palette.MUTED)
      }

      ForEach(MENU, (item: MenuItem) => {
        ArcListItem() {
          Column({ space: 2 }) {
            Text(item.title)
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor(item.color)
            Text(item.subtitle)
              .fontSize(11)
              .fontColor(Palette.MUTED)
              .maxLines(2)
          }
          .id(item.id)
          .width(ArcListLayout.ITEM_WIDTH)
          .padding({ top: 10, bottom: 10, left: 16, right: 16 })
          .alignItems(HorizontalAlign.Start)
          .borderRadius(24)
          .backgroundColor(Palette.SURFACE)
          .onClick(() => this.open(item))
        }
      }, (item: MenuItem) => item.id)
    }
    .id('homeMenu')
    .width('100%')
    .height('100%')
    .space(LengthMetrics.vp(ArcListLayout.SPACE))
    .digitalCrownSensitivity(CrownSensitivity.MEDIUM)
    .scrollBar(BarState.Off)
    .backgroundColor(Palette.BG)
  }

  private open(item: MenuItem): void {
    AppLog.info('Home', `Opened "${item.title}" -> ${item.route}`);
    if (item.startsFlow) {
      logger.beginFlow(item.title);
    }
    RouteManager.get().stack.pushPathByName(item.route, undefined);
  }
}
