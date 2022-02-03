import LineChart from "./line-chart";
import flatpickr from "flatpickr";

let Hooks = {}

Hooks.LineChart = {
    mounted() {
        const {labels, values} = JSON.parse(this.el.dataset.chartData)
        this.chart = new LineChart(this.el, labels, values)

        this.handleEvent("new-point", ({label, value}) => {
            console.log("Added point")
            this.chart.addPoint(label, value)
        })
    }
}

Hooks.InfiniteScroll = {
    mounted() {
        console.log("Footer added to DOM", this.el);
        const observer = new IntersectionObserver(entries => {
            const entry = entries[0];
            if (entry.isIntersecting) {
                console.log("Footer is visible");
                this.pushEvent("load-more")
            }
        });

        observer.observe(this.el);
    }
}

// Define a mounted callback and instantiated a
// flatpickr instance using this.el as the element.
// When a date is picked, use this.pushEvent()
// to push an event to the LiveView with the chosen
// date string as the payload.

Hooks.DatePicker = {
    mounted() {
        flatpickr(this.el, {
            enableTime: false,
            dateFormat: "F d, Y",
            onChange: this.handleDatePicked.bind(this),
        });
    },

    handleDatePicked(selectedDates, dateStr, instance) {
        this.pushEvent("dates-picked", dateStr);
    },
};

Hooks.PhoneNumber = {
    mounted() {
        this.el.addEventListener("input", e => {
            this.el.value = new AsYouType("US").input(this.el.value);
        });
    },
};

export default Hooks;