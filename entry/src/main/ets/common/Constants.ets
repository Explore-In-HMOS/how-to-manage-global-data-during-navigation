export class Routes {
  static readonly LOG: string = 'LifecycleLog';
  static readonly COMPARE: string = 'Compare';

  static readonly DASH_BROKEN: string = 'DashboardBroken';
  static readonly EDIT_BROKEN: string = 'EditGoalBroken';
  static readonly CONFIRM_BROKEN: string = 'ConfirmBroken';

  static readonly DASH_AS: string = 'DashboardAS';
  static readonly EDIT_AS: string = 'EditGoalAS';
  static readonly CONFIRM_AS: string = 'ConfirmAS';

  static readonly DASH_PR: string = 'DashboardPR';
  static readonly EDIT_PR: string = 'EditGoalPR';
  static readonly CONFIRM_PR: string = 'ConfirmPR';

  static readonly DASH_RM: string = 'DashboardRM';
  static readonly EDIT_RM: string = 'EditGoalRM';
  static readonly CONFIRM_RM: string = 'ConfirmRM';
}

export class StorageKeys {
  static readonly GOAL: string = 'navsync.goal';
}

export class ResultKeys {
  static readonly GOAL: string = 'goal';
}

export class GoalConfig {
  static readonly INITIAL: number = 8000;
  static readonly STEP: number = 500;
  static readonly MIN: number = 1000;
  static readonly MAX: number = 30000;
  static readonly CROWN_DEGREES_PER_STEP: number = 10;
}

export class LogConfig {
  static readonly DOMAIN: number = 0x0A11;
  static readonly TAG: string = 'NavSync';
  static readonly APP_TAG: string = 'NavSyncApp';
  static readonly MAX_ENTRIES: number = 300;
  static readonly STRIP_ENTRIES: number = 4;
}

export class Palette {
  static readonly BG: string = '#000000';
  static readonly SURFACE: string = '#1C1C1E';
  static readonly SURFACE_HI: string = '#2C2C2E';
  static readonly TEXT: string = '#FFFFFF';
  static readonly MUTED: string = '#8E8E93';
  static readonly GOOD: string = '#30D158';
  static readonly BAD: string = '#FF453A';
  static readonly WRITE: string = '#FFD60A';
  static readonly READ: string = '#64D2FF';
  static readonly NAV: string = '#BF5AF2';
}

export const PAGE_PADDING: Padding = { top: 40, bottom: 48, left: 28, right: 28 };

export class ArcListLayout {
  static readonly ITEM_WIDTH: string = '84%';
  static readonly SPACE: number = 8;
}
