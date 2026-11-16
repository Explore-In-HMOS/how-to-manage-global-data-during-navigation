import { AbilityConstant, ConfigurationConstant, errorManager, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { AppLog } from '../common/AppLog';

const MODULE: string = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  private errorObserverId: number | undefined = undefined;
  private createdAt: number = 0;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.createdAt = Date.now();
    AppLog.info(MODULE, `onCreate bundle=${want.bundleName ?? ''} launchReason=${launchParam.launchReason} ` +
      `lastExitReason=${launchParam.lastExitReason} lastExitMessage=${launchParam.lastExitMessage ?? ''}`);
    this.registerErrorObserver();
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      AppLog.error(MODULE, 'Failed to set colorMode', err as Object);
    }
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    AppLog.info(MODULE, `onNewWant launchReason=${launchParam.launchReason}`);
  }

  onDestroy(): void {
    AppLog.info(MODULE, 'onDestroy');
    this.unregisterErrorObserver();
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    AppLog.info(MODULE, 'onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        AppLog.error(MODULE, 'Failed to load pages/Index', err);
        return;
      }
      AppLog.info(MODULE, `pages/Index loaded, ${Date.now() - this.createdAt} ms after onCreate`);
    });
  }

  onWindowStageDestroy(): void {
    AppLog.info(MODULE, 'onWindowStageDestroy');
  }

  onForeground(): void {
    AppLog.info(MODULE, 'onForeground');
  }

  onBackground(): void {
    AppLog.info(MODULE, 'onBackground');
  }

  onMemoryLevel(level: AbilityConstant.MemoryLevel): void {
    AppLog.warn(MODULE, `onMemoryLevel level=${level}`);
  }

  private registerErrorObserver(): void {
    try {
      this.errorObserverId = errorManager.on('error', {
        onUnhandledException: (errMsg: string) => {
          AppLog.error('Uncaught', errMsg);
        },
        onException: (errObj: Error) => {
          AppLog.error('Uncaught', 'exception', errObj);
        }
      });
    } catch (err) {
      AppLog.error(MODULE, 'Failed to register error observer', err as Object);
    }
  }

  private unregisterErrorObserver(): void {
    if (this.errorObserverId === undefined) {
      return;
    }
    const id = this.errorObserverId;
    this.errorObserverId = undefined;
    errorManager.off('error', id).catch((err: Object) => {
      AppLog.warn(MODULE, `Failed to unregister error observer: ${AppLog.describe(err)}`);
    });
  }
}
