import { logger } from '../../common/LifecycleLogger';
import { DemoSettings, readAppStorageGoal } from '../../common/GoalStore';
import { GoalConfig, Palette, Routes, StorageKeys } from '../../common/Constants';
import { DashboardView } from '../../views/components/FlowViews';

const PAGE: string = 'Dash2';

@Builder
export function DashboardASBuilder() {
  DashboardAS()
}

@Component
struct DashboardAS {
  @StorageProp(StorageKeys.GOAL) @Watch('onGoalChanged') goal: number = GoalConfig.INITIAL;
  @State writeLate: boolean = DemoSettings.appStorageWritesLate;
  private stack: NavPathStack | undefined = undefined;

  aboutToAppear(): void {
    logger.lifecycle(PAGE, 'aboutToAppear', readAppStorageGoal());
  }

  aboutToDisappear(): void {
    logger.lifecycle(PAGE, 'aboutToDisappear', readAppStorageGoal());
  }

  onGoalChanged(): void {
    logger.read(PAGE, '@StorageProp UI update', this.goal);
  }

  @Builder
  writeLateSwitch() {
    Row({ space: 6 }) {
      Text('Write late (bad)')
        .fontSize(11)
        .fontColor(this.writeLate ? Palette.BAD : Palette.MUTED)
      Toggle({ type: ToggleType.Switch, isOn: this.writeLate })
        .id('writeLateToggle')
        .selectedColor(Palette.BAD)
        .onChange((isOn: boolean) => {
          this.writeLate = isOn;
          DemoSettings.appStorageWritesLate = isOn;
        })
    }
  }

  build() {
    NavDestination() {
      DashboardView({
        title: '2 · AppStorage',
        hint: 'UI stays correct either way. With "write late", the onShown read is ⚠ STALE.',
        goal: this.goal,
        onEdit: () => this.stack?.pushPathByName(Routes.EDIT_AS, this.goal),
        extra: () => {
          this.writeLateSwitch()
        }
      })
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.stack = ctx.pathStack;
      logger.lifecycle(PAGE, 'onReady', readAppStorageGoal());
    })
    .onWillAppear(() => logger.lifecycle(PAGE, 'onWillAppear', readAppStorageGoal()))
    .onAppear(() => logger.lifecycle(PAGE, 'onAppear', readAppStorageGoal()))
    .onWillShow(() => logger.lifecycle(PAGE, 'onWillShow', readAppStorageGoal()))
    .onShown(() => {
      logger.read(PAGE, 'onShown AppStorage.get', readAppStorageGoal());
    })
    .onWillHide(() => logger.lifecycle(PAGE, 'onWillHide', readAppStorageGoal()))
    .onHidden(() => logger.lifecycle(PAGE, 'onHidden', readAppStorageGoal()))
    .onWillDisappear(() => logger.lifecycle(PAGE, 'onWillDisappear', readAppStorageGoal()))
    .onDisAppear(() => logger.lifecycle(PAGE, 'onDisAppear', readAppStorageGoal()))
  }
}
