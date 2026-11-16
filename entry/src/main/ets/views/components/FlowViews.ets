import { PAGE_PADDING, Palette } from '../../common/Constants';
import { GoalEditor } from './GoalEditor';
import { LogStrip } from './LogStrip';

@Builder
function noExtra() {
}

@Component
export struct DashboardView {
  @Prop title: string = '';
  @Prop hint: string = '';
  @Prop goal: number = 0;
  onEdit: () => void = () => {
  };
  @BuilderParam extra: () => void = noExtra;

  build() {
    Scroll() {
      Column({ space: 8 }) {
        Text(this.title)
          .fontSize(14)
          .fontColor(Palette.MUTED)
        Text('Daily step goal')
          .fontSize(12)
          .fontColor(Palette.MUTED)
        Text(this.goal.toString())
          .id('goalValue')
          .fontSize(44)
          .fontWeight(FontWeight.Bold)
          .fontColor(Palette.TEXT)
        Button('Edit')
          .id('editBtn')
          .width('70%')
          .height(40)
          .backgroundColor(Palette.GOOD)
          .fontColor(Palette.BG)
          .onClick(() => this.onEdit())
        this.extra()
        Text(this.hint)
          .fontSize(11)
          .fontColor(Palette.MUTED)
          .textAlign(TextAlign.Center)
          .padding({ left: 8, right: 8 })
        LogStrip()
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .padding(PAGE_PADDING)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .backgroundColor(Palette.BG)
  }
}

@Component
export struct EditGoalView {
  @Prop title: string = '';
  @Link value: number;
  onSave: () => void = () => {
  };
  onNext: () => void = () => {
  };
  onCancel: () => void = () => {
  };

  build() {
    Scroll() {
      Column({ space: 8 }) {
        Text(this.title)
          .fontSize(14)
          .fontColor(Palette.MUTED)
        GoalEditor({ value: $value })
        Button('Save')
          .id('saveBtn')
          .width('70%')
          .height(40)
          .backgroundColor(Palette.GOOD)
          .fontColor(Palette.BG)
          .onClick(() => this.onSave())
        Button('Review…')
          .id('nextBtn')
          .width('70%')
          .height(36)
          .backgroundColor(Palette.SURFACE_HI)
          .onClick(() => this.onNext())
        Button('Cancel')
          .id('cancelBtn')
          .width('70%')
          .height(36)
          .backgroundColor(Palette.SURFACE_HI)
          .fontColor(Palette.MUTED)
          .onClick(() => this.onCancel())
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .padding(PAGE_PADDING)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .backgroundColor(Palette.BG)
  }
}

@Component
export struct ConfirmView {
  @Prop title: string = '';
  @Prop value: number = 0;
  onSave: () => void = () => {
  };
  onCancel: () => void = () => {
  };

  build() {
    Column({ space: 10 }) {
      Text(this.title)
        .fontSize(14)
        .fontColor(Palette.MUTED)
      Text(`Save ${this.value}?`)
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .fontColor(Palette.TEXT)
      Text('Returns straight to the Dashboard')
        .fontSize(11)
        .fontColor(Palette.MUTED)
      Button('Save')
        .id('confirmSaveBtn')
        .width('70%')
        .height(40)
        .backgroundColor(Palette.GOOD)
        .fontColor(Palette.BG)
        .onClick(() => this.onSave())
      Button('Back')
        .id('confirmCancelBtn')
        .width('70%')
        .height(36)
        .backgroundColor(Palette.SURFACE_HI)
        .onClick(() => this.onCancel())
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding(PAGE_PADDING)
    .backgroundColor(Palette.BG)
  }
}
