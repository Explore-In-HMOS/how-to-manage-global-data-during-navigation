import { GoalConfig, StorageKeys } from './Constants';

export class GoalStore {
  static goal: number = GoalConfig.INITIAL;
}

export class DemoSettings {
  static appStorageWritesLate: boolean = false;
}

export function readAppStorageGoal(): number {
  return AppStorage.get<number>(StorageKeys.GOAL) ?? GoalConfig.INITIAL;
}
