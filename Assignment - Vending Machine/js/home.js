// JavaScript source code
$(document).ready(() => {
    clearAllInput();
    setPurchasing();
    setCountToZero
})

// ---------- UI helper functions ---------- 
function clearTable() {
    $('#itemList').empty();
}
function clearAllInput() {
    clearErrorMessage();
    clearTotalMoney();
    clearChangeRemains();
    clearItemSelect();
    loadTable();
}
function clearErrorMessage() {
    $('#errorMessages').val('');
    $('#errorMessages').text('');
}
function clearTotalMoney() {
    $('#storedMoney').val(0);
    $('#storedMoney').text('');
}
function clearItemSelect() {
    $('#storedItemId').text('');
    $('#storedItemId').val(0);
}
function clearChangeRemains() {
    $('#returnChange').val('');
    $('#returnChange').text('');
}

// ---------- Logic helper functions ---------- 
function roundMoney(money) {
    return Math.round(money * 100) / 100;
}
function setPurchased() {
    $('#successPurchase').val(1);
}
function setPurchasing() {
    $('#successPurchase').val(0);
}
function setCountToZero() {
    $('#dollarCount').val(0);
    $('#quarterCount').val(0);
    $('#dimeCount').val(0);
    $('#nickelCount').val(0);
}
function increaseCount(type) {
    var iDollar = roundMoney($('#dollarCount').val());
    var iQuarter = roundMoney($('#quarterCount').val());
    var iDime = roundMoney($('#dimeCount').val());
    var iNickel = roundMoney($('#nickelCount').val());
    if (type == 'dollar') {
        iDollar += 1;
    } else if (type == 'quarter') {
        iQuarter += 1;
    } else if (type == 'dime') {
        iDime += 1;
    } else {
        iNickel += 1;
    }
    $('#dollarCount').val(iDollar);
    $('#quarterCount').val(iQuarter);
    $('#dimeCount').val(iDime);
    $('#nickelCount').val(iNickel);
}
function getTotalMoney() {
    return $('#storedMoney').val();
}
// ---------- Main functions ----------
function changeReturn() {
    console.log('changeReturn: ' + $('#successPurchase').val());
    if ($('#successPurchase').val() == 1) {
        clearAllInput();
    } else {
        if (getTotalMoney != 0) {
            var dollars = $('#dollarCount').val();
            var quarters = $('#dollarCount').val();
            var dimes = $('#dimeCount').val();
            var nickels = $('#nickelCount').val();
            $('#returnChange').text('' + dollars + ' dollar(s), ' + quarters + ' quarter(s), ' + dimes + ' dime(s), ' + nickels + ' nickel(s)') + ' is your change.');
            clearTotalMoney();
        }
    }
}

function selectItem(itemId) {
    if ($('#successPurchase').val() == 1) {
        clearAllInput();
    } 
    clearErrorMessage();
    clearItemSelect();
    $('#storedItemId').text(itemId);
    $('#storedItemId').val(itemId);
    console.log($('#storedItemId').val());
    loadTable();
    
}

function makePurchase() {
    var itemId = $('#storedItemId').val();
    var payment = $('#storedMoney').val();
    console.log('storedItemId: ' + itemId);
    console.log('storedMoney: ' + payment);
    
    $.ajax({
        type: 'POST',
        url: 'http://vending.us-east-1.elasticbeanstalk.com/money/' + payment + '/item/' + itemId,
        success: function (data) {
            $('#messageBox').val("Thank you!!!");
            $('#returnChange').text('' + data.quarters + ' quarter(s), ' + data.dimes + ' dime(s), ' + data.nickels + ' nickel(s), and ' + data.pennies + ' penn' + ((data.pennies === 1) ? 'y' : 'ies') + ' is your change.');
            loadTable();
            setPurchased();
            $('#errorMessages').text('Thank You!!!');
        },
        statusCode: {
            422: function (e) {
                console.log(e.responseText);
                $('#errorMessages').text($.parseJSON(e.responseText).message);
            }
        }
    });

}

// stored money at Number($('#storedMoney').val())
function addMoney(type) {
    if ($('#successPurchase').val() == 1) {
        clearAllInput();
    }
    clearErrorMessage();
    var currentMoney = roundMoney($('#storedMoney').val());
    if (type == 'dollar') {
        currentMoney += 1.00;
    } else if (type == 'quarter') {
        currentMoney += 0.25;
    } else if (type == 'dime') {
        currentMoney += 0.10;
    } else {
        currentMoney += 0.05;
    }
    increaseCount(type);
    currentMoney = roundMoney(currentMoney);
    $('#storedMoney').val(currentMoney);
    $('#storedMoney').text($('#storedMoney').val());
    console.log("moneyVal: " + $('#storedMoney').val());
}

// Populate table from database
function loadTable() {
    clearTable();
    var itemList = $('#itemList');

    $.ajax({
        type: 'GET',
        url: 'http://vending.us-east-1.elasticbeanstalk.com/items',
        success: function (itemArray) {
            $.each(itemArray, function (index, item) {
                var itemId = item.id;
                var name = item.name;
                var price = item.price;
                var quantity = item.quantity;

                var box = '<div class="col-4 border bg-light item-option" style="height: 120px;" onclick="selectItem(';
                box += itemId;
                box += ')">';
                box += '<div class="text-left" style="font-size:10pt;">';
                box += itemId;
                box += '</div>';
                box += '<div class="text-center">';
                box += name;
                box += '<br/>';
                box += '$' + price;
                box += '<br/>';
                box += 'Quantity Left: ' + quantity;
                box += '</div>';
                box += '</div>';
                 
                itemList.append(box);
            })
        },
        error: function () {
            $('#errorMessages')
                .append($('<li>')
                    .attr({ class: 'list-group-item list-group-item-danger' })
                    .text('Error calling web service. Please try again later.'));
        }
    })
}
