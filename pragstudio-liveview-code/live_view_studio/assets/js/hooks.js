let Hooks = {}

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

export default Hooks;