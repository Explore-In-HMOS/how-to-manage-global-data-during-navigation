import { GoalConfig, Palette } from '../../common/Constants';

@Component
export struct GoalEditor {
  @Link value: number;
  private crownAccumulated: number = 0;

  build() {
    Column({ space: 6 }) {
      Text(this.value.toString())
        .id('editValue')
        .fontSize(40)
        .fontWeight(FontWeight.Bold)
        .fontColor(Palette.TEXT)
      Row({ space: 20 }) {
        Button('−', { type: ButtonType.Circle })
          .id('minusBtn')
          .width(52)
          .height(52)
          .fontSize(26)
          .fontColor(Palette.TEXT)
          .backgroundColor(Palette.SURFACE_HI)
          .onClick(() => this.step(-1))
        Button('+', { type: ButtonType.Circle })
          .id('plusBtn')
          .width(52)
          .height(52)
          .fontSize(26)
          .fontColor(Palette.TEXT)
          .backgroundColor(Palette.SURFACE_HI)
          .onClick(() => this.step(1))
      }
      Text('Turn the crown to adjust')
        .fontSize(11)
        .fontColor(Palette.MUTED)
    }
    .focusable(true)
    .defaultFocus(true)
    .focusOnTouch(true)
    .onDigitalCrown((event: CrownEvent) => {
      this.crownAccumulated += event.degree;
      while (this.crownAccumulated >= GoalConfig.CROWN_DEGREES_PER_STEP) {
        this.crownAccumulated -= GoalConfig.CROWN_DEGREES_PER_STEP;
        this.step(1);
      }
      while (this.crownAccumulated <= -GoalConfig.CROWN_DEGREES_PER_STEP) {
        this.crownAccumulated += GoalConfig.CROWN_DEGREES_PER_STEP;
        this.step(-1);
      }
      event.stopPropagation();
    })
  }

  private step(direction: number): void {
    const next = this.value + direction * GoalConfig.STEP;
    this.value = Math.min(GoalConfig.MAX, Math.max(GoalConfig.MIN, next));
  }
}
