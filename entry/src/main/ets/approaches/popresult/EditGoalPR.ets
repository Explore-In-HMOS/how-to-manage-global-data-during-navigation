import { logger } from '../../common/LifecycleLogger';
import { GoalConfig, Routes } from '../../common/Constants';
import { EditGoalView } from '../../views/components/FlowViews';

const PAGE: string = 'Edit3';

@Builder
export function EditGoalPRBuilder() {
  EditGoalPR()
}

@Component
struct EditGoalPR {
  @State value: number = GoalConfig.INITIAL;
  private stack: NavPathStack | undefined = undefined;
  private callerOnPop: ((popInfo: PopInfo) => void) | undefined = undefined;

  aboutToAppear(): void {
    logger.lifecycle(PAGE, 'aboutToAppear', this.value);
  }

  aboutToDisappear(): void {
    logger.lifecycle(PAGE, 'aboutToDisappear', this.value);
  }

  private save(): void {
    logger.expect(this.value);
    logger.write(PAGE, 'Save: pop(result)', this.value);
    this.stack?.pop(this.value);
  }

  private openConfirm(): void {
    const info = new NavPathInfo(Routes.CONFIRM_PR, this.value, (popInfo: PopInfo) => {
      logger.lifecycle(PAGE, 'onPop from Confirm, forwarding', this.value);
      if (this.callerOnPop !== undefined) {
        this.callerOnPop(popInfo);
      }
    });
    this.stack?.pushPath(info);
  }

  build() {
    NavDestination() {
      EditGoalView({
        title: '3 · Edit goal',
        value: $value,
        onSave: () => this.save(),
        onNext: () => this.openConfirm(),
        onCancel: () => this.stack?.pop()
      })
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.stack = ctx.pathStack;
      this.value = ctx.pathInfo.param as number;
      this.callerOnPop = ctx.pathInfo.onPop;
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
