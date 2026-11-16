import { GoalConfig, Palette, StorageKeys } from '../common/Constants';
import { AppLog } from '../common/AppLog';
import { RouteManager } from '../common/RouteManager';
import { HomePage } from '../views/HomePage';

@Entry
@Component
struct Index {
  private routeManager: RouteManager = RouteManager.get();

  aboutToAppear(): void {
    AppStorage.setOrCreate<number>(StorageKeys.GOAL, GoalConfig.INITIAL);
    this.routeManager.installInterception();
    AppLog.info('Index', `Root Navigation ready, goal=${AppStorage.get<number>(StorageKeys.GOAL)}`);
  }

  build() {
    Navigation(this.routeManager.stack) {
      HomePage()
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .hideToolBar(true)
    .width('100%')
    .height('100%')
    .backgroundColor(Palette.BG)
  }
}
