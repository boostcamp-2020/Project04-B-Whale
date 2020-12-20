const todayNotificationId = 'todayCards';
let initAlarms = false;

chrome.alarms.clearAll();

const createNotification = ({name, opts}) => {
  chrome.notifications.create(name, opts, (id) => {
    setTimeout(() => {
      chrome.notifications.clear(id);
    }, 5000);
  });
}

const createTodayAlarms = (todayCardCount) => {
  const opts = {
    type: "basic",
    iconUrl: "/images/BoosTrello_Logo.png",
    title: "오늘의 일정",
    message: `오늘 총 ${todayCardCount}개의 일정이 있습니다.`
  }

  createNotification({name: todayNotificationId, opts});
}

const createAlarms = ({card, when}) => {
  const cardId = `card${card.id}`
  const data = {};
  data[cardId] = card;
  
  chrome.storage.local.set(data, () => {
    chrome.alarms.create(cardId, {when: when});
  });
}

const removeAlarms = (id) => {
  const cardId = `card${id}`;
  chrome.alarms.clear(cardId);
}

chrome.runtime.onMessageExternal.addListener(async (request) => {
  if (request.action === `set_notification`) {
    if(initAlarms) return;
    initAlarms = true;
    const todayCardCount = request.todayCardCount;
    createTodayAlarms(todayCardCount);

    const { cards } = request;
    cards.forEach(card => {
      const dueDate = new Date(card.dueDate);
      const preOneHours = dueDate.setHours(dueDate.getHours() - 1);
      const now = Date.now();
      
      if(dueDate <= now) return;

      createAlarms({card, when: preOneHours});
    });
    return;
  };
  if(request.action === `add_notification`) {
    const {card} = request;
    const dueDate = new Date(card.dueDate);
    const preOneHours = dueDate.setHours(dueDate.getHours() - 1);
    const now = Date.now();
    
    if(dueDate <= now) return;

    createAlarms({card, when: preOneHours});
    return;
  }
  if(request.action === 'remove_notification') {
    const {cardId} = request;
    
    removeAlarms(cardId);
    return;
  }
});

chrome.alarms.onAlarm.addListener((alarm) => {
  const {name} = alarm;
  
  chrome.storage.local.get(name, (result) => {
    const {title} = result[name];
    const opts = {
      type: "basic",
      iconUrl: "/images/BoosTrello_Logo.png",
      title: title,
      message: "해당 일정의 마감기한이 1시간 남았습니다."
    }

    createNotification({name, opts});
  })
});
