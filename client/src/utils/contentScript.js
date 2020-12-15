/* eslint-disable no-undef */
const extensionId = process.env.REACT_APP_WHALE_ID;

export const initNotification = ({ cards, todayCardCount }) => {
    chrome.runtime.sendMessage(extensionId, {
        action: 'set_notification',
        cards,
        todayCardCount,
    });
};

export const addNotification = (card) => {
    chrome.runtime.sendMessage(extensionId, {
        action: 'add_notification',
        card,
    });
};

export const removeNotification = (cardId) => {
    chrome.runtime.sendMessage(extensionId, {
        action: 'remove_notification',
        cardId,
    });
};
