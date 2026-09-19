import QtQuick 2.0
import Amber.Mpris 1.0

// MPRIS media control — lockscreen widget + media keys. Loaded via a Loader so that if the
// org.nemomobile.mpris plugin isn't installed, this file simply fails to load rather than
// breaking the app. `np` is the app's nowPlaying object, injected by the Loader.
MprisPlayer {
    id: mpris
    property var np: null

    serviceName: "fintune"
    identity: "FinTune"

    canControl: true
    canPlay: true
    canPause: true
    canGoNext: !!(np && np.hasNext)
    canGoPrevious: !!(np && np.hasPrev)
    canSeek: false
    canQuit: false
    canRaise: false

    playbackStatus: (np && np.active)
                    ? (np.playing ? Mpris.Playing : Mpris.Paused)
                    : Mpris.Stopped

    onPlayPauseRequested: if (np) np.toggleRequested()
    onPlayRequested: if (np && !np.playing) np.toggleRequested()
    onPauseRequested: if (np && np.playing) np.toggleRequested()
    onStopRequested: if (np && np.playing) np.toggleRequested()
    onNextRequested: if (np) np.nextRequested()
    onPreviousRequested: if (np) np.prevRequested()

    //Metadata changes
    onPlaybackStatusChanged: setMetaData()

    function setMetaData() {
        if (np && np.title !== metaData.title) metaData.title = np.title
        if (np && np.channel !== metaData.contributingArtist) metaData.contributingArtist = np.channel
        if (np && np.thumb !== metaData.artUrl) metaData.artUrl = np.thumb
    }
}
