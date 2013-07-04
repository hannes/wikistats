Rickshaw.namespace('Rickshaw.Graph.Behavior.Series.Remove');


Rickshaw.Graph.Behavior.Series.Remove = function(args) {

	this.graph = args.graph;
	this.legend = args.legend;

	var self = this;

	this.addAnchor = function(line) {
		var anchor = document.createElement('a');
		anchor.innerHTML = '&#10007;';
		anchor.classList.add('action');
		line.element.insertBefore(anchor, line.element.firstChild);

		anchor.onclick = function(e) {
				console.log(line.series)
				line.series.remove();
		};
		
             

	};
	


	if (this.legend) {

		if (typeof $ != 'undefined' && $(this.legend.list).sortable) {

			$(this.legend.list).sortable( {
				start: function(event, ui) {
					ui.item.bind('no.onclick',
						function(event) {
							event.preventDefault();
						}
					);
				},
				stop: function(event, ui) {
					setTimeout(function(){
						ui.item.unbind('no.onclick');
					}, 250);
				}
			});
		}

		this.legend.lines.forEach( function(l) {
			self.addAnchor(l);
		} );
	}

	this._addBehavior = function() {

		this.graph.series.forEach( function(s) {
			
			s.remove = function() {
				console.log(self.graph.series);
				
				self.graph.update();
			};


		} );
	};
	this._addBehavior();

	this.updateBehaviour = function () { this._addBehavior() };

};