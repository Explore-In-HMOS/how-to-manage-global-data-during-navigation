import { logger } from '../../common/LifecycleLogger';
import { GoalConfig, Routes } from '../../common/Constants';
import { DashboardView } from '../../views/components/FlowViews';

const PAGE: string = 'Dash3';

@Builder
export function DashboardPRBuilder() {
  DashboardPR()
}

@Component
struct DashboardPR {
  @State goal: number = GoalConfig.INITIAL;
  private stack: NavPathStack | undefined = undefined;

  aboutToAppear(): void {
    logger.lifecycle(PAGE, 'aboutToAppear', this.goal);
  }

  aboutToDisappear(): void {
    logger.lifecycle(PAGE, 'aboutToDisappear', this.goal);
  }

  private openEditor(): void {
    const info = new NavPathInfo(Routes.EDIT_PR, this.goal, (popInfo: PopInfo) => this.onEditResult(popInfo));
    this.stack?.pushPath(info);
  }

  private onEditResult(popInfo: PopInfo): void {
    if (typeof popInfo.result !== 'number') {
      logger.lifecycle(PAGE, 'onPop (no result)', this.goal);
      return;
    }
    this.goal = popInfo.result as number;
    logger.read(PAGE, `onPop result from ${popInfo.info.name}`, this.goal);
  }

  build() {
    NavDestination() {
      DashboardView({
        title: '3 · pop(result)',
        hint: 'Result arrives through onPop. No global state is involved.',
        goal: this.goal,
        onEdit: () => this.openEditor()
      })
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.stack = ctx.pathStack;
      logger.lifecycle(PAGE, 'onReady', this.goal);
    })
    .onWillAppear(() => logger.lifecycle(PAGE, 'onWillAppear', this.goal))
    .onAppear(() => logger.lifecycle(PAGE, 'onAppear', this.goal))
    .onWillShow(() => logger.lifecycle(PAGE, 'onWillShow', this.goal))
    .onShown(() => logger.read(PAGE, 'onShown this.goal', this.goal))
    .onWillHide(() => logger.lifecycle(PAGE, 'onWillHide', this.goal))
    .onHidden(() => logger.lifecycle(PAGE, 'onHidden', this.goal))
    .onWillDisappear(() => logger.lifecycle(PAGE, 'onWillDisappear', this.goal))
    .onDisAppear(() => logger.lifecycle(PAGE, 'onDisAppear', this.goal))
  }
}
