QueryString = {  
    data: {},  
    Initial: function() {  

        var aPairs, aTmp;  
        var queryString;

        queryString = new String(window.location.search);  
        queryString = queryString.substr(1, queryString.length); //remove   "?"     
        aPairs = queryString.split("&");  

        for (var i = 0; i < aPairs.length; i++) {  
            
            aTmp = aPairs[i].split("=");  
            this.data[aTmp[0]] = aTmp[1];  
        }  
    },  
    GetValue: function(key) {  
        return this.data[key];  
    }  
};

var Request = {  
    data: {},  
    init: function() {  

        var aPairs, aTmp;  
        var queryString;

        queryString = new String(window.location.search);  
        queryString = queryString.substr(1, queryString.length); //remove   "?"     
        aPairs = queryString.split("&");  

        for (var i = 0; i < aPairs.length; i++) {  
            
            aTmp = aPairs[i].split("=");  
            this.data[aTmp[0]] = aTmp[1];  
        }

        return this;
    },  
    getValue: function(key, defaultValue) {  

        var value;

        defaultValue = undefined == defaultValue ? -1 : defaultValue;

        value = this.data[key];
        value = undefined == value || 'undefined' == value || '' == value ? defaultValue : value;

        return value;  
    }  
}  