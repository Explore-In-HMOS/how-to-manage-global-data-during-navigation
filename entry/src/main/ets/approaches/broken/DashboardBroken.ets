import { logger } from '../../common/LifecycleLogger';
import { GoalStore } from '../../common/GoalStore';
import { Routes } from '../../common/Constants';
import { DashboardView } from '../../views/components/FlowViews';

const PAGE: string = 'Dash1';

@Builder
export function DashboardBrokenBuilder() {
  DashboardBroken()
}

@Component
struct DashboardBroken {
  @State goal: number = GoalStore.goal;
  private stack: NavPathStack | undefined = undefined;

  aboutToAppear(): void {
    logger.lifecycle(PAGE, 'aboutToAppear', GoalStore.goal);
  }

  aboutToDisappear(): void {
    logger.lifecycle(PAGE, 'aboutToDisappear', GoalStore.goal);
  }

  build() {
    NavDestination() {
      DashboardView({
        title: '1 · Broken',
        hint: 'Edit writes the global in aboutToDisappear. Watch for ⚠ STALE.',
        goal: this.goal,
        onEdit: () => this.stack?.pushPathByName(Routes.EDIT_BROKEN, this.goal)
      })
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.stack = ctx.pathStack;
      logger.lifecycle(PAGE, 'onReady', GoalStore.goal);
    })
    .onWillAppear(() => logger.lifecycle(PAGE, 'onWillAppear', GoalStore.goal))
    .onAppear(() => logger.lifecycle(PAGE, 'onAppear', GoalStore.goal))
    .onWillShow(() => logger.lifecycle(PAGE, 'onWillShow', GoalStore.goal))
    .onShown(() => {
      this.goal = GoalStore.goal;
      logger.read(PAGE, 'onShown read global', this.goal);
    })
    .onWillHide(() => logger.lifecycle(PAGE, 'onWillHide', GoalStore.goal))
    .onHidden(() => logger.lifecycle(PAGE, 'onHidden', GoalStore.goal))
    .onWillDisappear(() => logger.lifecycle(PAGE, 'onWillDisappear', GoalStore.goal))
    .onDisAppear(() => logger.lifecycle(PAGE, 'onDisAppear', GoalStore.goal))
  }
}
