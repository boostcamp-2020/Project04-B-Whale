import React, { useState } from 'react';
import ActivityContext from '../../context/ActivityContext';

const ActivityProvider = ({ children }) => {
    const [activities, setActivities] = useState([]);

    return (
        <ActivityContext.Provider value={{ activities, setActivities }}>
            {children}
        </ActivityContext.Provider>
    );
};

export default ActivityProvider;
