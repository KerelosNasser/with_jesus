package com.example.with_jesus.native

import android.content.ContentUris
import android.content.Context
import android.provider.BaseColumns
import android.provider.MediaStore
import androidx.annotation.VisibleForTesting
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MediaStoreChannel(private val context: Context) : MethodChannel.MethodCallHandler {

    companion object {
        @VisibleForTesting
        val SEARCH_KEYWORDS = listOf(
            "choir",
            "كورال",
            "ترنيمة",
            "مديح",
            "مسيح",
            "الرب",
            "echo band",
            "david's heart",
            "better life",
            "قلب داود",
            "فيك الحياة",
            "ترانيم",
            "christiane najjar",
            "القداس",
            "AVA-TAKLA",
            "boles malak",
        )
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "scanCopticAudio" -> {
                try {
                    val audioList = queryCopticAudio()
                    result.success(audioList)
                } catch (e: Exception) {
                    result.error("SCAN_FAILED", e.message, null)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun queryCopticAudio(): List<Map<String, Any?>> {
        val projection = arrayOf(
            BaseColumns._ID,
            MediaStore.Audio.Media.TITLE,
            MediaStore.Audio.Media.ARTIST,
            MediaStore.Audio.Media.ALBUM,
            MediaStore.Audio.Media.DURATION,
        )

        val resultList = mutableListOf<Map<String, Any?>>()

        context.contentResolver.query(
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
            projection,
            null,
            null,
            null,
        )?.use { cursor ->
            val idCol = cursor.getColumnIndexOrThrow(BaseColumns._ID)
            val titleCol = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.TITLE)
            val artistCol = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.ARTIST)
            val albumCol = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.ALBUM)
            val durationCol = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DURATION)

            while (cursor.moveToNext()) {
                val id = cursor.getLong(idCol)
                val title = cursor.getString(titleCol) ?: ""
                val artist = cursor.getString(artistCol) ?: ""
                val album = cursor.getString(albumCol) ?: ""
                val duration = cursor.getLong(durationCol)

                if (matchesKeyword(title, artist, album)) {
                    val contentUri = ContentUris.withAppendedId(
                        MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                        id,
                    )
                    resultList.add(
                        mapOf(
                            "id" to id.toString(),
                            "title" to title,
                            "artist" to artist,
                            "album" to album,
                            "duration" to duration,
                            "uri" to contentUri.toString(),
                        ),
                    )
                }
            }
        }

        return resultList
    }

    private fun matchesKeyword(title: String, artist: String, album: String): Boolean {
        val lowerTitle = title.lowercase()
        val lowerArtist = artist.lowercase()
        val lowerAlbum = album.lowercase()
        return SEARCH_KEYWORDS.any { keyword ->
            val lowerKeyword = keyword.lowercase()
            lowerTitle.contains(lowerKeyword) ||
                lowerArtist.contains(lowerKeyword) ||
                lowerAlbum.contains(lowerKeyword)
        }
    }
}
