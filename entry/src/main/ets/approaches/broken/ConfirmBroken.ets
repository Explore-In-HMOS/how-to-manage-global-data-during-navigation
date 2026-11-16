import { logger } from '../../common/LifecycleLogger';
import { GoalStore } from '../../common/GoalStore';
import { Routes } from '../../common/Constants';
import { ConfirmView } from '../../views/components/FlowViews';

const PAGE: string = 'Conf1';

@Builder
export function ConfirmBrokenBuilder() {
  ConfirmBroken()
}

@Component
struct ConfirmBroken {
  @State value: number = GoalStore.goal;
  private saved: boolean = false;
  private stack: NavPathStack | undefined = undefined;

  aboutToAppear(): void {
    logger.lifecycle(PAGE, 'aboutToAppear', GoalStore.goal);
  }

  aboutToDisappear(): void {
    logger.lifecycle(PAGE, 'aboutToDisappear', GoalStore.goal);
    if (this.saved) {
      GoalStore.goal = this.value;
      logger.write(PAGE, 'aboutToDisappear write global', this.value);
    }
  }

  build() {
    NavDestination() {
      ConfirmView({
        title: '1 · Confirm',
        value: this.value,
        onSave: () => {
          logger.expect(this.value);
          this.saved = true;
          this.stack?.popToName(Routes.DASH_BROKEN);
        },
        onCancel: () => this.stack?.pop()
      })
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.stack = ctx.pathStack;
      this.value = ctx.pathInfo.param as number;
      logger.lifecycle(PAGE, 'onReady', GoalStore.goal);
    })
    .onWillAppear(() => logger.lifecycle(PAGE, 'onWillAppear', GoalStore.goal))
    .onAppear(() => logger.lifecycle(PAGE, 'onAppear', GoalStore.goal))
    .onWillShow(() => logger.lifecycle(PAGE, 'onWillShow', GoalStore.goal))
    .onShown(() => logger.lifecycle(PAGE, 'onShown', GoalStore.goal))
    .onWillHide(() => logger.lifecycle(PAGE, 'onWillHide', GoalStore.goal))
    .onHidden(() => logger.lifecycle(PAGE, 'onHidden', GoalStore.goal))
    .onWillDisappear(() => logger.lifecycle(PAGE, 'onWillDisappear', GoalStore.goal))
    .onDisAppear(() => logger.lifecycle(PAGE, 'onDisAppear', GoalStore.goal))
  }
}
