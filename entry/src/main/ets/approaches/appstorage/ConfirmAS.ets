import { logger } from '../../common/LifecycleLogger';
import { DemoSettings, readAppStorageGoal } from '../../common/GoalStore';
import { Routes, StorageKeys } from '../../common/Constants';
import { ConfirmView } from '../../views/components/FlowViews';

const PAGE: string = 'Conf2';

@Builder
export function ConfirmASBuilder() {
  ConfirmAS()
}

@Component
struct ConfirmAS {
  @State value: number = readAppStorageGoal();
  private pendingLateWrite: boolean = false;
  private stack: NavPathStack | undefined = undefined;

  aboutToAppear(): void {
    logger.lifecycle(PAGE, 'aboutToAppear', readAppStorageGoal());
  }

  aboutToDisappear(): void {
    logger.lifecycle(PAGE, 'aboutToDisappear', readAppStorageGoal());
    if (this.pendingLateWrite) {
      AppStorage.set<number>(StorageKeys.GOAL, this.value);
      logger.write(PAGE, 'aboutToDisappear AppStorage.set', this.value);
    }
  }

  private save(): void {
    logger.expect(this.value);
    if (DemoSettings.appStorageWritesLate) {
      this.pendingLateWrite = true;
    } else {
      AppStorage.set<number>(StorageKeys.GOAL, this.value);
      logger.write(PAGE, 'Save: AppStorage.set, then popToName', this.value);
    }
    this.stack?.popToName(Routes.DASH_AS);
  }

  build() {
    NavDestination() {
      ConfirmView({
        title: '2 · Confirm',
        value: this.value,
        onSave: () => this.save(),
        onCancel: () => this.stack?.pop()
      })
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.stack = ctx.pathStack;
      this.value = ctx.pathInfo.param as number;
      logger.lifecycle(PAGE, 'onReady', readAppStorageGoal());
    })
    .onWillAppear(() => logger.lifecycle(PAGE, 'onWillAppear', readAppStorageGoal()))
    .onAppear(() => logger.lifecycle(PAGE, 'onAppear', readAppStorageGoal()))
    .onWillShow(() => logger.lifecycle(PAGE, 'onWillShow', readAppStorageGoal()))
    .onShown(() => logger.lifecycle(PAGE, 'onShown', readAppStorageGoal()))
    .onWillHide(() => logger.lifecycle(PAGE, 'onWillHide', readAppStorageGoal()))
    .onHidden(() => logger.lifecycle(PAGE, 'onHidden', readAppStorageGoal()))
    .onWillDisappear(() => logger.lifecycle(PAGE, 'onWillDisappear', readAppStorageGoal()))
    .onDisAppear(() => logger.lifecycle(PAGE, 'onDisAppear', readAppStorageGoal()))
  }
}
