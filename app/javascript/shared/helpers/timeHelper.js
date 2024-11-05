import {
  isSameYear,
  fromUnixTime,
  formatDistanceToNow,
  isSameDay,
} from 'date-fns';
import * as locales from 'date-fns/locale';

const selectedLocaleToDateFns = (locale = 'en') => {
  return locales[locale.replace('_', '')];
};

/**
 * Provides a formatted timestamp, adjusting the format based on the current year.
 * @param {number} time - Unix timestamp.
 * @param {string} [locale='en'] - Desired locale and region.
 * @returns {string} Formatted date string.
 */
export const messageTimestamp = (time, locale = 'en') => {
  const messageTime = fromUnixTime(time);
  const now = new Date();
  let options;
  if (isSameYear(messageTime, now)) {
    options = {
      dateStyle: 'medium',
      timeStyle: 'short',
    };
    if (isSameDay(messageTime, now)) {
      options = {
        timeStyle: 'short',
      };
    }
  } else {
    options = {
      dateStyle: 'medium',
    };
  }

  return new Intl.DateTimeFormat(locale.replace('_', '-'), options).format(
    messageTime
  );
};

/**
 * Converts a Unix timestamp to a relative time string (e.g., 3 hours ago).
 * @param {number} time - Unix timestamp.
 * @param {string} [locale='en'] - Desired locale and region.
 * @returns {string} Relative time string.
 */
export const dynamicTime = (time, locale) => {
  const unixTime = fromUnixTime(time);
  return formatDistanceToNow(unixTime, {
    addSuffix: true,
    locale: selectedLocaleToDateFns(locale),
  });
};

/**
 * Formats a Unix timestamp into a specified date format.
 * @param {number} time - Unix timestamp.
 * @param {string} [locale='en'] - Desired locale and region.
 * @returns {string} Formatted date string.
 */
export const dateFormat = (time, formatStyle = 'medium', locale = 'en') => {
  const unixTime = fromUnixTime(time);
  const options = {};
  switch (formatStyle) {
    case 'short':
      options.dateStyle = 'short';
      break;
    case 'medium':
      options.dateStyle = 'medium';
      break;
    case 'long':
      options.dateStyle = 'long';
      break;
    case 'full':
      options.dateStyle = 'medium';
      options.timeStyle = 'medium';
      break;
    default:
      options.dateStyle = 'medium';
  }

  return new Intl.DateTimeFormat(locale.replace('_', '-'), options).format(
    unixTime
  );
};

/**
 * Converts a detailed time description into a shorter format, optionally appending 'ago'.
 * @param {string} time - Detailed time description (e.g., 'a minute ago').
 * @param {boolean} [withAgo=false] - Whether to append 'ago' to the result.
 * @param {string} [locale='en'] - Desired locale and region.
 * @returns {string} Shortened time description.
 */
export const shortTimestamp = (time, withAgo = false, locale = 'en') => {
  const unixTime = fromUnixTime(time);
  return formatDistanceToNow(unixTime, {
    addSuffix: withAgo,
    locale: selectedLocaleToDateFns(locale),
  });
};
