import { logger } from '../../common/LifecycleLogger';
import { GoalConfig, ResultKeys, Routes } from '../../common/Constants';
import { RouteManager } from '../../common/RouteManager';
import { ResultListener } from '../../common/RouteCore';
import { DashboardView } from '../../views/components/FlowViews';

const PAGE: string = 'Dash4';

function readGoal(): number {
  const value = RouteManager.get().getResult(ResultKeys.GOAL);
  return value === undefined ? GoalConfig.INITIAL : value as number;
}

@Builder
export function DashboardRMBuilder() {
  DashboardRM()
}

@Component
struct DashboardRM {
  @State goal: number = readGoal();
  private routeManager: RouteManager = RouteManager.get();
  private goalListener: ResultListener = (value: Object) => {
    this.goal = value as number;
    logger.read(PAGE, 'onResult listener', this.goal);
  };

  aboutToAppear(): void {
    this.routeManager.onResult(ResultKeys.GOAL, this.goalListener);
    logger.lifecycle(PAGE, 'aboutToAppear', readGoal());
  }

  aboutToDisappear(): void {
    this.routeManager.offResult(ResultKeys.GOAL, this.goalListener);
    logger.lifecycle(PAGE, 'aboutToDisappear', readGoal());
  }

  build() {
    NavDestination() {
      DashboardView({
        title: '4 · RouteManager',
        hint: 'back() commits the result, then pops. Data is ready before onWillShow.',
        goal: this.goal,
        onEdit: () => this.routeManager.push(Routes.EDIT_RM, this.goal)
      })
    }
    .hideTitleBar(true)
    .onReady(() => logger.lifecycle(PAGE, 'onReady', readGoal()))
    .onWillAppear(() => logger.lifecycle(PAGE, 'onWillAppear', readGoal()))
    .onAppear(() => logger.lifecycle(PAGE, 'onAppear', readGoal()))
    .onWillShow(() => logger.read(PAGE, 'onWillShow getResult', readGoal()))
    .onShown(() => logger.read(PAGE, 'onShown getResult', readGoal()))
    .onWillHide(() => logger.lifecycle(PAGE, 'onWillHide', readGoal()))
    .onHidden(() => logger.lifecycle(PAGE, 'onHidden', readGoal()))
    .onWillDisappear(() => logger.lifecycle(PAGE, 'onWillDisappear', readGoal()))
    .onDisAppear(() => logger.lifecycle(PAGE, 'onDisAppear', readGoal()))
  }
}
