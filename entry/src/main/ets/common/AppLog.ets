import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { LogConfig } from './Constants';

export class AppLog {
  static debug(module: string, message: string): void {
    hilog.debug(LogConfig.DOMAIN, LogConfig.APP_TAG, '[%{public}s] %{public}s', module, message);
  }

  static info(module: string, message: string): void {
    hilog.info(LogConfig.DOMAIN, LogConfig.APP_TAG, '[%{public}s] %{public}s', module, message);
  }

  static warn(module: string, message: string): void {
    hilog.warn(LogConfig.DOMAIN, LogConfig.APP_TAG, '[%{public}s] %{public}s', module, message);
  }

  static error(module: string, message: string, err?: Object): void {
    const detail = err === undefined ? '' : ` | ${AppLog.describe(err)}`;
    hilog.error(LogConfig.DOMAIN, LogConfig.APP_TAG, '[%{public}s] %{public}s%{public}s', module, message, detail);
  }

  static describe(err: Object): string {
    if (err instanceof Error) {
      const code = (err as BusinessError).code;
      const codeText = code === undefined ? '' : ` code=${code}`;
      const stack = err.stack === undefined ? '' : ` stack=${err.stack.replace(/\n\s*/g, ' <- ')}`;
      return `${err.name}: ${err.message}${codeText}${stack}`;
    }
    try {
      return JSON.stringify(err);
    } catch (e) {
      return String(err);
    }
  }
}
