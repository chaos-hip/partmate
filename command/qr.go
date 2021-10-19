package command

import (
	"flag"
	"fmt"
	"image"
	"path"

	"github.com/fogleman/gg"
	"github.com/lithammer/shortuuid/v3"
	"github.com/sirupsen/logrus"
	qrcode "github.com/skip2/go-qrcode"
)

const (
	// DIN A4 paper in portrait when 300 dpi are used (mm * 11.81 to get the pixels)

	// Width of the paper
	a4WidthInPx = 2480

	// Height of the paper
	a4HeightInPx = 3508

	// Size of a QR code itself (about 15,2mm)
	qrCodeSizePx = 180

	// Border around each QR code used for cut marks
	cellBorderWidthPx = 1

	// Page border around the whole page
	pageBorderPx = 60

	pageBorderBottomPx = 120
)

// QR is a command used to bulk-create a set of
type QR struct {
	fs *flag.FlagSet
	// The filename to use when writing the PNG file containing the QR codes
	outputFile string
	// The base URL to use for the QR codes
	baseUrl string
}

func NewQR() *QR {
	out := &QR{
		fs: flag.NewFlagSet("qr", flag.ExitOnError),
	}
	out.fs.StringVar(&out.outputFile, "o", "./qr.png", "Output image to write the QR codes to")
	out.fs.StringVar(&out.baseUrl, "url", "https://i.repaircafe-hilpolstein.de", "The base URL to use (without trailing slash)")
	return out
}

func (q *QR) createCodeImage(code string) (image.Image, error) {
	out := image.NewRGBA(image.Rect(0, 0, qrCodeSizePx+(2*cellBorderWidthPx), qrCodeSizePx+(cellBorderWidthPx*3)))
	bounds := out.Bounds()
	dc := gg.NewContextForRGBA(out)
	dc.SetHexColor("cccccc")
	dc.SetLineWidth(1)
	dc.DrawRectangle(0, 0, float64(bounds.Dx()), float64(bounds.Dy()))
	dc.Stroke()
	url := path.Join(q.baseUrl, "l", code)
	qrCode, err := qrcode.New(url, qrcode.Highest)
	if err != nil {
		return nil, fmt.Errorf("failed to generate QR code: %w", err)
	}
	dc.DrawImage(qrCode.Image(qrCodeSizePx), cellBorderWidthPx, cellBorderWidthPx)
	return out, nil
}

// Run implements the Command interface by having a runnable function that gets passed the commandline arguments
func (q *QR) Run(args []string) error {
	if err := q.fs.Parse(args); err != nil {
		return fmt.Errorf("failed to parse commandline arguments")
	}
	cellHeight := qrCodeSizePx + (cellBorderWidthPx * 3)
	cellsX := (a4WidthInPx - (2 * pageBorderPx)) / (qrCodeSizePx + (2 * cellBorderWidthPx))
	cellsY := (a4HeightInPx - (pageBorderPx + pageBorderBottomPx)) / cellHeight
	logrus.Infof("Generating %dx%d QR codes - %d in total", cellsX, cellsY, cellsX*cellsY)
	out := image.NewRGBA(image.Rect(0, 0, a4WidthInPx, a4HeightInPx))
	dc := gg.NewContextForRGBA(out)
	dc.SetHexColor("ffffff")
	dc.DrawRectangle(0, 0, a4WidthInPx, a4HeightInPx)
	dc.Fill()
	for yPos := 0; yPos < cellsY; yPos++ {
		for xPos := 0; xPos < cellsX; xPos++ {
			code := shortuuid.New()
			img, err := q.createCodeImage(code)
			if err != nil {
				return fmt.Errorf("%d, %d: failed to generate output: %w", xPos, yPos, err)
			}
			bounds := img.Bounds()
			x := pageBorderPx + (bounds.Dx() * xPos)
			y := pageBorderPx + (bounds.Dy() * yPos)
			dc.DrawImage(img, x, y)
		}
	}
	return dc.SavePNG(q.outputFile)
}
