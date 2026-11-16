import { AppLog } from './AppLog';
import { RouteCore, StackLike } from './RouteCore';
import { logger } from './LifecycleLogger';

const MODULE: string = 'Route';

class NavPathStackAdapter implements StackLike {
  private navStack: NavPathStack;

  constructor(navStack: NavPathStack) {
    this.navStack = navStack;
  }

  push(name: string, param?: Object): void {
    this.navStack.pushPathByName(name, param);
  }

  pop(): void {
    this.navStack.pop();
  }

  popToName(name: string): void {
    if (this.navStack.popToName(name) < 0) {
      AppLog.warn(MODULE, `popToName(${name}): no such page in the stack, nothing popped`);
    }
  }
}

export class RouteManager extends RouteCore {
  private static instance: RouteManager | undefined = undefined;
  readonly stack: NavPathStack;

  private constructor(stack: NavPathStack) {
    super(new NavPathStackAdapter(stack));
    this.stack = stack;
  }

  static get(): RouteManager {
    if (RouteManager.instance === undefined) {
      RouteManager.instance = new RouteManager(new NavPathStack());
    }
    return RouteManager.instance;
  }

  installInterception(): void {
    AppLog.info(MODULE, 'Navigation interception installed');
    this.stack.setInterception({
      willShow: (from: NavDestinationContext | NavBar, to: NavDestinationContext | NavBar,
        operation: NavigationOperation) => {
        logger.nav('willShow', `${RouteManager.nameOf(from)}→${RouteManager.nameOf(to)} ${RouteManager.opName(operation)}`);
      },
      didShow: (from: NavDestinationContext | NavBar, to: NavDestinationContext | NavBar,
        operation: NavigationOperation) => {
        const transition = `${RouteManager.nameOf(from)}→${RouteManager.nameOf(to)} ${RouteManager.opName(operation)}`;
        logger.nav('didShow', transition);
        AppLog.info(MODULE, `${transition} depth=${this.stack.size()}`);
      }
    });
  }

  private static nameOf(target: NavDestinationContext | NavBar): string {
    if (typeof target === 'string') {
      return 'Home';
    }
    return (target as NavDestinationContext).pathInfo.name;
  }

  private static opName(operation: NavigationOperation): string {
    switch (operation) {
      case NavigationOperation.PUSH:
        return 'PUSH';
      case NavigationOperation.POP:
        return 'POP';
      case NavigationOperation.REPLACE:
        return 'REPLACE';
      default:
        return 'OTHER';
    }
  }
}
