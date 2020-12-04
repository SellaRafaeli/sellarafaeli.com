var server = 'http://localhost:4200/';

var log = console.log
console.log("in guidde.js");

var pbs = {}

function buildResults(playbooks) {
	var html = playbooks.map(pb => {
		pbs[pb.id] = pb;
		return `<div class="single_playbook" onclick=pbclick("${pb.id}")>
			<div class="single_pb_top">
				<div class="pb_type">${pb.type || "Team"}</div>
				<div class="pb_title">${pb.title || "My Title"}</div>
			</div>
			<div class="single_pb_bottom">
				<img class='pb_creator_img' src='${server+'/'+pb.creator_img}' />
				<div class='pb_bottom_row_one'>
					<span class="creator_name">${pb.creator_name || "Jane Simmons"}</span>
					<span class="time_ago">${pb.time_ago || "3 days ago"}</span>
				</div>
				<div class='pb_bottom_row_two'>
					Rating <span class="rating">${pb.rating || "4.1"}</span>
				</div>
			</div>
		</div>`
	});
	return html;
}

function showVideo(url) {
	$("#video_player").css('display','block');
	$("#youtube_iframe").attr('src',url);
	$("#results").html('');
}

function stopVideo() {
	$('#youtube_iframe').each(function(){
	  this.contentWindow.postMessage('{"event":"command","func":"stopVideo","args":""}', '*')
	});
	$("#video_player").css("display","none");
}

function pbclick(pbID) {
	var pb = pbs[pbID];
	console.log('click',pb)
	showVideo(pb.url+'?enablejsapi=1');
}

function search(val) {
	var text = val || $("#search").val()
	console.log('searching for '+text);
	$.get(server+`/guidde/search?val=${text}`).then(_res => {
		var res = buildResults(_res.playbooks)
		log('res',res);
		$("#results").html(res);
	})
}

function runGuidde() {
	$.get(server+'/guidde').then(res => {
		var div = document.createElement('div');
		div.innerHTML = res;
		document.body.appendChild(div);

		//search('test');
	});


}

runGuidde();