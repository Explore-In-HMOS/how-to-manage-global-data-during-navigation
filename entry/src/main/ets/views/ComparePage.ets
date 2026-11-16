import {
  ArcList, ArcListAttribute, ArcListItem, ArcListItemAttribute, ComponentContent, LengthMetrics
} from '@kit.ArkUI';
import { ArcListLayout, Palette } from '../common/Constants';
import { ArcHeaderParams, createArcHeader } from './components/ArcHeader';

class CompareCard {
  title: string;
  color: string;
  lines: string[];

  constructor(title: string, color: string, lines: string[]) {
    this.title = title;
    this.color = color;
    this.lines = lines;
  }
}

const RULE: string = 'Commit data BEFORE pop / popToName / replacePath. Never in aboutToDisappear.';

const CARDS: CompareCard[] = [
  new CompareCard('1 · Write in aboutToDisappear', Palette.BAD, [
    'Previous page is shown before teardown',
    'onShown reads the old value',
    'Never do this'
  ]),
  new CompareCard('2 · AppStorage', Palette.GOOD, [
    'Scope: app-wide, reactive UI',
    'Logic in onShown is safe only if written before pop',
    'Best for: settings, user, theme'
  ]),
  new CompareCard('3 · pop(result) + onPop', Palette.GOOD, [
    'Scope: caller and callee only',
    'Result delivered with the pop',
    'Best for: pick-and-return flows'
  ]),
  new CompareCard('4 · RouteManager', Palette.GOOD, [
    'Scope: app-wide, typed API',
    'Commits, then pops: safe by design',
    'Best for: many flows, interception, tests'
  ])
];

@Builder
export function ComparePageBuilder() {
  ComparePage()
}

@Component
struct ComparePage {
  private header?: ComponentContent<ArcHeaderParams>;

  aboutToAppear(): void {
    this.header = createArcHeader(this.getUIContext(), 'Compare');
  }

  build() {
    NavDestination() {
      ArcList({ header: this.header }) {
        ArcListItem() {
          Text(RULE)
            .width(ArcListLayout.ITEM_WIDTH)
            .fontSize(11)
            .fontColor(Palette.WRITE)
            .textAlign(TextAlign.Center)
        }

        ForEach(CARDS, (card: CompareCard) => {
          ArcListItem() {
            Column({ space: 2 }) {
              Text(card.title)
                .width('100%')
                .fontSize(13)
                .fontWeight(FontWeight.Medium)
                .fontColor(card.color)
                .textAlign(TextAlign.Start)
              ForEach(card.lines, (line: string) => {
                Row({ space: 6 }) {
                  Text('•')
                    .fontSize(11)
                    .fontColor(Palette.MUTED)
                  Text(line)
                    .layoutWeight(1)
                    .fontSize(11)
                    .fontColor(Palette.TEXT)
                    .textAlign(TextAlign.Start)
                }
                .width('100%')
                .alignItems(VerticalAlign.Top)
              }, (line: string) => line)
            }
            .width(ArcListLayout.ITEM_WIDTH)
            .alignItems(HorizontalAlign.Start)
            .padding({ top: 12, bottom: 12, left: 16, right: 16 })
            .borderRadius(20)
            .backgroundColor(Palette.SURFACE)
          }
        }, (card: CompareCard) => card.title)
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
