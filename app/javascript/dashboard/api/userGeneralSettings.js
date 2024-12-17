/* global axios */
import ApiClient from './ApiClient';

class UserGeneralPreferences extends ApiClient {
  constructor() {
    super('general_preferences', { accountScoped: true });
  }

  update(params) {
    return axios.patch(`${this.url}`, params);
  }
}

export default new UserGeneralPreferences();
