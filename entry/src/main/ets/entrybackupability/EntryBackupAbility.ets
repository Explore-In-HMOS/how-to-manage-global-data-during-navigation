import { BackupExtensionAbility, BundleVersion } from '@kit.CoreFileKit';
import { AppLog } from '../common/AppLog';

const MODULE: string = 'Backup';

export default class EntryBackupAbility extends BackupExtensionAbility {
  async onBackup() {
    AppLog.info(MODULE, 'onBackup ok');
    await Promise.resolve();
  }

  async onRestore(bundleVersion: BundleVersion) {
    AppLog.info(MODULE, `onRestore ok ${JSON.stringify(bundleVersion)}`);
    await Promise.resolve();
  }
}
