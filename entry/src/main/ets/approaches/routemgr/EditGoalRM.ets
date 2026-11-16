import { logger } from '../../common/LifecycleLogger';
import { GoalConfig, ResultKeys, Routes } from '../../common/Constants';
import { RouteManager } from '../../common/RouteManager';
import { EditGoalView } from '../../views/components/FlowViews';

const PAGE: string = 'Edit4';

@Builder
export function EditGoalRMBuilder() {
  EditGoalRM()
}

@Component
struct EditGoalRM {
  @State value: number = GoalConfig.INITIAL;
  private routeManager: RouteManager = RouteManager.get();

  aboutToAppear(): void {
    logger.lifecycle(PAGE, 'aboutToAppear', this.value);
  }

  aboutToDisappear(): void {
    logger.lifecycle(PAGE, 'aboutToDisappear', this.value);
  }

  private save(): void {
    logger.expect(this.value);
    logger.write(PAGE, 'Save: RouteManager.back (commit, then pop)', this.value);
    this.routeManager.back(ResultKeys.GOAL, this.value);
  }

  build() {
    NavDestination() {
      EditGoalView({
        title: '4 · Edit goal',
        value: $value,
        onSave: () => this.save(),
        onNext: () => this.routeManager.push(Routes.CONFIRM_RM, this.value),
        onCancel: () => this.routeManager.back()
      })
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
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
