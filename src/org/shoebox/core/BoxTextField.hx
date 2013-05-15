/**
*  HomeMade by shoe[box]
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions are
*  met:
*
* Redistributions of source code must retain the above copyright notice,
*   this list of conditions and the following disclaimer.
*
* Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the
*    documentation and/or other materials provided with the distribution.
*
* Neither the name of shoe[box] nor the names of its
* contributors may be used to endorse or promote products derived from
* this software without specific prior written permission.
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
* IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
* THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
* PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package org.shoebox.core;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author shoe[box]
 */

class BoxTextField{

	// -------o constructor


	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function format( tf : TextField , sAutoSize : Dynamic , bSelectable : Bool = false , bWordWrap : Bool = true , bMultiLine : Bool = false ) : Void {

			if ( sAutoSize == null )
				sAutoSize = TextFieldAutoSize.LEFT;

			tf.selectable 	= bSelectable;
			tf.multiline 	= bMultiLine;
			tf.wordWrap 	= bWordWrap;
			tf.autoSize		= sAutoSize;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function setFormat(
									tf			: TextField ,
									bEmbedFonts	: Bool = true ,
									sFontName		: String = null,
									iFontSize		: Int = 12 ,
									iCol			: Int ,
									sAlign		= null,
									?bBold		: Bool = false
								) : Void {

			tf.embedFonts = bEmbedFonts;
			tf.defaultTextFormat = new TextFormat( sFontName , iFontSize , iCol , bBold , false , null , null , null , sAlign );

		}

	// -------o protected



	// -------o misc

}