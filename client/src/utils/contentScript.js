/* eslint-disable no-undef */
const extensionId = process.env.REACT_APP_WHALE_ID;

export const initNotification = ({ cards, todayCardCount }) => {
    chrome.runtime.sendMessage(extensionId, {
        action: 'set_notification',
        cards,
        todayCardCount,
    });
};
