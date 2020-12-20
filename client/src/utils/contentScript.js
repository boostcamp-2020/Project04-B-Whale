/* eslint-disable no-undef */
const extensionId = process.env.REACT_APP_WHALE_ID;

export const initNotification = ({ cards, todayCardCount }) => {
    if (!extensionId) return;
    try {
        chrome.runtime.sendMessage(extensionId, {
            action: 'set_notification',
            cards,
            todayCardCount,
        });
    } catch (e) {
        console.error('올바르지 않은 웨일 확장앱 ID입니다.');
    }
};

export const addNotification = (card) => {
    if (!extensionId) return;
    try {
        chrome.runtime.sendMessage(extensionId, {
            action: 'add_notification',
            card,
        });
    } catch (e) {
        console.error('올바르지 않은 웨일 확장앱 ID입니다.');
    }
};

export const removeNotification = (cardId) => {
    if (!extensionId) return;
    try {
        chrome.runtime.sendMessage(extensionId, {
            action: 'remove_notification',
            cardId,
        });
    } catch (e) {
        console.error('올바르지 않은 웨일 확장앱 ID입니다.');
    }
};
