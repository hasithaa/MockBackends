import ballerina/http;
import ballerina/time;

final readonly & table<CurrencyRate> key(sourceCurrency, targetCurrency) currencyRates = table [
    {sourceCurrency: "USD", targetCurrency: "LKR", rate: 300.0},
    {sourceCurrency: "LKR", targetCurrency: "USD", rate: 0.005},
    {sourceCurrency: "USD", targetCurrency: "INR", rate: 75.0},
    {sourceCurrency: "INR", targetCurrency: "USD", rate: 0.013},
    {sourceCurrency: "USD", targetCurrency: "EUR", rate: 0.85},
    {sourceCurrency: "EUR", targetCurrency: "USD", rate: 1.18},
    {sourceCurrency: "USD", targetCurrency: "GBP", rate: 0.73},
    {sourceCurrency: "GBP", targetCurrency: "USD", rate: 1.37},
    {sourceCurrency: "USD", targetCurrency: "JPY", rate: 110.0},
    {sourceCurrency: "JPY", targetCurrency: "USD", rate: 0.0091},
    {sourceCurrency: "USD", targetCurrency: "AUD", rate: 1.3},
    {sourceCurrency: "AUD", targetCurrency: "USD", rate: 0.77}
];

service on new http:Listener(9090) {
    resource function get .(ConversionRequest req) returns ConversionResponse|http:NotFound {
        do {
            CurrencyRate rate = check trap currencyRates.get([req.sourceCurrency, req.targetCurrency]);
            var date = check time:civilToString(time:utcToCivil(time:utcNow()));
            return {rate: rate.rate, date};
        }
        on fail {
            return <http:NotFound>{body: "Currency rate not found"};
        }
    }
}

type CurrencyRate record {|
    readonly string sourceCurrency;
    readonly string targetCurrency;
    decimal rate;
|};

type ConversionRequest record {|
    string sourceCurrency;
    string targetCurrency;
|};

type ConversionResponse record {|
    decimal rate;
    string date;
|};
