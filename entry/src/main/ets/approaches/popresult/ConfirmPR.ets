import { logger } from '../../common/LifecycleLogger';
import { GoalConfig, Routes } from '../../common/Constants';
import { ConfirmView } from '../../views/components/FlowViews';

const PAGE: string = 'Conf3';

@Builder
export function ConfirmPRBuilder() {
  ConfirmPR()
}

@Component
struct ConfirmPR {
  @State value: number = GoalConfig.INITIAL;
  private stack: NavPathStack | undefined = undefined;

  aboutToAppear(): void {
    logger.lifecycle(PAGE, 'aboutToAppear', this.value);
  }

  aboutToDisappear(): void {
    logger.lifecycle(PAGE, 'aboutToDisappear', this.value);
  }

  private save(): void {
    logger.expect(this.value);
    logger.write(PAGE, 'Save: popToName(Dash, result)', this.value);
    this.stack?.popToName(Routes.DASH_PR, this.value);
  }

  build() {
    NavDestination() {
      ConfirmView({
        title: '3 · Confirm',
        value: this.value,
        onSave: () => this.save(),
        onCancel: () => this.stack?.pop()
      })
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.stack = ctx.pathStack;
      this.value = ctx.pathInfo.param as number;
      logger.lifecycle(PAGE, 'onReady (param)', this.value);
    })
    .onWillAppear(() => logger.lifecycle(PAGE, 'onWillAppear', this.value))
    .onAppear(() => logger.lifecycle(PAGE, 'onAppear', this.value))
    .onWillShow(() => logger.lifecycle(PAGE, 'onWillShow', this.value))
    .onShown(() => logger.lifecycle(PAGE, 'onShown', this.value))
    .onWillHide(() => logger.lifecycle(PAGE, 'onWillHide', this.value))
    .onHidden(() => logger.lifecycle(PAGE, 'onHidden', this.value))
    .onWillDisappear(() => logger.lifecycle(PAGE, 'onWillDisappear', this.value))
    .onDisAppear(() => logger.lifecycle(PAGE, 'onDisAppear', this.value))
  }
}
